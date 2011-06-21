Attribute VB_Name = "Engine_Inventory"
Option Explicit

Dim InventoryOffset As Long             'Number of lines we scrolled down from topmost
Public SelectedItem As Long             'Currently selected item

'Dim InvSurface As DirectDrawSurface7            'DD Surface used to render everything

Dim UserInventory(1 To MAX_INVENTORY_SLOTS) As Inventory    'User's inventory

'Dim WithEvents InventoryWindow As PictureBox    'Placeholder where to render the inventory

#If ConMenuesConextuales = 1 Then
    Dim ItemMenu As Menu    'Menu to be shown as pop up
#End If

Dim last_i As Byte

Dim invtl(3) As TLVERTEX
Public dibujar_tooltip_inv As Integer
Dim slots(1 To 6) As Byte

Public inv_tooltip_counter As Integer

Public Sub DrawInventory()
    Dim i As Long
    Dim x!
    Dim y!
    Dim tt$
    Call GetTexture(9719)
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, invtl(0), TL_size
    For i = 1 To MAX_INVENTORY_SLOTS
        If UserInventory(i).GrhIndex Then
            x = ((i - 1) Mod 4) * 37 + 5
            y = ((i - 1) \ 4) * 37 + 5
            
            If SelectedItem = i Then
                Call Engine.Draw_FilledBox(x, y, 32, 32, &H7F000000, &H7FCC0000)
                Grh_Render_invselslot x, y
            End If
            
            Call Engine.Grh_Render_nocolor(UserInventory(i).GrhIndex, x, y)
            If UserInventory(i).Amount > 1 Then Call Engine.Text_Render_ext(CStr(UserInventory(i).Amount), y, x, 40, 40, &HFFFFFFFF)
            If UserInventory(i).Equipped Then
                Call Engine.Text_Render_ext("+", y + 20!, x + 20!, 40!, 40!, &HFFFFFF00)
            End If
        End If
    Next i
    For i = 1 To 6
        If slots(i) Then
            Call Engine.Grh_Render_nocolor(UserInventory(slots(i)).GrhIndex, Special_slots_rect(i - 1).Left + 5, Special_slots_rect(i - 1).Top + 5)
        End If
    Next i
    If dibujar_tooltip_inv And inv_tooltip_counter > 3 Then
        With UserInventory(dibujar_tooltip_inv)
            If Len(.name) Then
                tt = .name
                If .Def Then tt = tt & vbNewLine & Chr$(255) & " Def: " & Chr$(255) & .Def
                If .MaxHit Then tt = tt & vbNewLine & Chr$(255) & " Hit: " & Chr$(255) & .MinHit & "/" & .MaxHit
            End If
        End With
        If Len(tt) Then
            
            If inv_tooltip_counter = 4 Then
            Call Engine.Draw_FilledBox(5, 154, 142, 41, &H7F000000, &H9F363636, 2)
            Engine.Text_Render_alpha tt, 155, 9, &HFFFFFFFF, 0, 100
            Else
            Call Engine.Draw_FilledBox(5, 154, 142, 41, &H9F000000, &HBF363636, 2)
            Engine.Text_Render_alpha tt, 155, 9, &HFFFFFFFF, 0, 200
            End If
        End If
    End If
End Sub


Public Sub set_Slots(ByVal slot As Byte, ByVal obj_slot As Byte)
On Error Resume Next
slots(slot) = obj_slot
End Sub

Public Sub reset_slots()
Dim i As Integer
For i = 1 To 6
slots(i) = 0
Next i
End Sub

Public Sub Inventory_init()
On Error Resume Next
    frmMain.ImageList1.MaskColor = vbBlack
    frmMain.ImageList1.UseMaskColor = True
    init_gui_tl invtl, 0, 0, 199, 200
    SelectedItem = ClickItem(1, 1)   'If there is anything there we select the top left item
End Sub

Public Property Get MaxHit(ByVal slot As Byte) As Integer
    MaxHit = UserInventory(slot).MaxHit
End Property

Public Property Get MinHit(ByVal slot As Byte) As Integer
    MinHit = UserInventory(slot).MinHit
End Property

Public Property Get Def(ByVal slot As Byte) As Integer
    Def = UserInventory(slot).Def
End Property

Public Property Get GrhIndex(ByVal slot As Byte) As Integer
    GrhIndex = UserInventory(slot).GrhIndex
End Property

Public Property Get Flags(ByVal slot As Byte) As Single
    Flags = UserInventory(slot).Flags
End Property

Public Property Get Amount(ByVal slot As Byte) As Long
    If slot = FLAGORO Then
        Amount = UserGLD
    ElseIf slot >= LBound(UserInventory) And slot <= UBound(UserInventory) Then
        Amount = UserInventory(slot).Amount
    End If
End Property

Public Property Get OBJIndex(ByVal slot As Byte) As Integer
    OBJIndex = UserInventory(slot).OBJIndex
End Property

Public Property Get OBJType(ByVal slot As Byte) As Integer
    OBJType = UserInventory(slot).OBJType
End Property

Public Property Get ItemName(ByVal slot As Byte) As String
    ItemName = UserInventory(slot).name
End Property

Public Property Get Equipped(ByVal slot As Byte) As Boolean
    Equipped = UserInventory(slot).Equipped
End Property

Public Sub InvSetItem(ByVal slot As Byte, ByVal eOBJIndex As Integer, ByVal eAmount As Integer, ByVal eEquipped As Byte, _
                        ByVal eGrhIndex As Integer, ByVal eObjType As Integer, ByVal eMaxHit As Integer, ByVal eMinHit As Integer, _
                        ByVal eDef As Integer, ByVal Flags As Long, ByVal eName As String)
    If slot < 1 Or slot > MAX_INVENTORY_SLOTS Then Exit Sub
    
    With UserInventory(slot)
        .Amount = eAmount
        .Def = eDef
        .Equipped = eEquipped
        .GrhIndex = eGrhIndex
        .MaxHit = eMaxHit
        .MinHit = eMinHit
        .name = eName
        .OBJIndex = eOBJIndex
        .OBJType = eObjType
        .Flags = Flags
    End With
End Sub

Private Function ClickItem(ByVal x As Long, ByVal y As Long) As Long
    Dim TempItem As Long
    Dim temp_x As Long
    Dim temp_y As Long
    
    temp_x = x \ 37
    temp_y = y \ 37
    
    TempItem = temp_x + (temp_y + InventoryOffset) * (148 \ 37) + 1
    If TempItem > MAX_INVENTORY_SLOTS Then TempItem = 1
    'Make sure it's within limits
    If TempItem <= MAX_INVENTORY_SLOTS Then
        'Make sure slot isn't empty
        If UserInventory(TempItem).GrhIndex Then
            ClickItem = TempItem
        Else
            ClickItem = 0
        End If
        DrawInventory
    End If
End Function

Function buscari(gh As Integer) As Integer
Dim i As Integer
'BUSQUEDA BINARIA?
' LAS PELOTAS
' PAJA
For i = 1 To frmMain.ImageList1.ListImages.count
    If frmMain.ImageList1.ListImages(i).Key = "g" & CStr(gh) Then
        buscari = i
        Exit For
    End If
Next i
End Function

Public Sub InventoryWindow_MouseDown(Button As Integer, Shift As Integer, x As Single, y As Single)
inv_tooltip_counter = 0
re_render_inventario = True

    Dim TempItem As Integer
    Dim tss As Integer
    'Exit if it got outside the control's area
    click_sslot x, y, TempItem, tss
    If x < 0 Or y < 0 Or x > 149 Or y > 149 Then
        If tss > 0 Then
        
        End If
    Else
        If UserInventory(TempItem).GrhIndex > 0 Then
            frmMain.picInv.MousePointer = vbCustom
            If Button = vbRightButton Then
                last_i = TempItem
                If last_i > 0 And last_i < 13 Then
                    Dim poss As Integer
                    poss = buscari(UserInventory(TempItem).GrhIndex)
                    If poss = 0 Then
                         DoEvents
                         frmMain.ImageList1.ListImages.Add , CStr("g" & UserInventory(TempItem).GrhIndex), Picture:=clsPak_LeerIPicture(pakGraficos, CInt(GrhData(UserInventory(TempItem).GrhIndex).FileNum)) 'General_Load_Picture_From_Resource1(GrhData(UserInventory(TempItem).GrhIndex).FileNum & ".bmp") 'ax
                         poss = frmMain.ImageList1.ListImages.count
                    End If
                    Set frmMain.picInv.MouseIcon = frmMain.ImageList1.ListImages(poss).ExtractIcon
                    Exit Sub
                End If
            End If
        End If
    End If

erra:
frmMain.picInv.MouseIcon = Nothing
last_i = 0
frmMain.picInv.MousePointer = vbArrow

End Sub



Public Sub InventoryWindow_MouseMove(Button As Integer, Shift As Integer, x As Single, y As Single)

    Dim temp_x As Integer
    Dim temp_y As Integer
    Dim TempItem As Integer
    
    If Button <> vbRightButton Then frmMain.picInv.MousePointer = vbDefault
    
    If x < 0 Or y < 0 Or x > 149 Or y > 149 Then _
        Exit Sub
    
    temp_x = x \ 37
    temp_y = y \ 37
    
    TempItem = temp_x + (temp_y + InventoryOffset) * (148 \ 37) + 1
    If TempItem > MAX_INVENTORY_SLOTS Then TempItem = 1
    
    'If TempItem <= MAX_INVENTORY_SLOTS Then
    '    frmmain.picinv.ToolTipText = UserInventory(TempItem).name
    'End If
    
    If frmMain.picInv.MousePointer = vbDefault Then dibujar_tooltip_inv = TempItem
    
End Sub

Public Sub InventoryWindow_MouseUp(Button As Integer, Shift As Integer, x As Single, y As Single)
inv_tooltip_counter = 0
re_render_inventario = True
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Implements the mouse up event of the inventory picture box
'Check outs which item was clicked
'***************************************************
    'Store previously selected item
    Dim prevSelItem As Long
        Dim TempItem As Integer
        Dim tss As Integer
    'Exit if it got outside the control's area
    
    click_sslot x, y, TempItem, tss
If x < 0 Or y < 0 Or x > 149 Or y > 149 Then
    If tss > 0 And tss < 7 Then
        Protocol.WriteEquipItem last_i
        'If button = vbRightButton And last_i <> Special_slots(tss) Then
        '    Debug.Print tss & "sitem < " & last_i
        'End If
    End If
Else
    prevSelItem = SelectedItem

    'Get the currently clickced item
    SelectedItem = ClickItem(CInt(x), CInt(y))
    
    If Button = vbRightButton And last_i <> TempItem Then
        Debug.Print TempItem & " < " & last_i
        If last_i <> TempItem And last_i < 13 And TempItem < 13 And last_i > 0 And TempItem > 0 Then
            If UserInventory(last_i).GrhIndex > 0 Then
                Call WriteMoveItem(last_i, TempItem)
                Call FlushBuffer
                'Dim iasd As Inventory
                'Dim cleared As Inventory
                'iasd = UserInventory(last_i)
                'UserInventory(last_i) = UserInventory(TempItem)
                'UserInventory(TempItem) = iasd
                'DrawInventorySlot last_i
                'DrawInventorySlot TempItem
                Call WriteRequestPositionUpdate
            End If
        End If
    End If
    frmMain.picInv.DragIcon = Nothing
    frmMain.picInv.MousePointer = vbDefault
    last_i = 0

End If
#If ConMenuesConextuales = 1 Then
    'If it was a right click on the same item we had selected before, show popup menu
    If Button = vbRightButton And prevSelItem = SelectedItem Then
        'Show the provided menu as a popup
        Call frmMain.picInv.Parent.PopupMenu(ItemMenu, , x, y)
    End If
#End If
End Sub

Private Sub click_sslot(x!, y!, ByRef Item%, Optional ByRef sslot%)
Dim i%
Item = (x + 4) \ 37 + ((y + 4) \ 37) * (148 \ 37) + 1

For i = 0 To 5
    If Collision_sRect(x, y, Special_slots_rect(i)) Then
        sslot = i + 1
        Exit For
    End If
Next i
If Item > MAX_INVENTORY_SLOTS Then Item = MAX_INVENTORY_SLOTS
End Sub


