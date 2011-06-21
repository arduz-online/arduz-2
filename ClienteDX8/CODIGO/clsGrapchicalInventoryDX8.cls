VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsGrapchicalInventory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Attribute VB_Ext_KEY = "SavedWithClassBuilder6" ,"Yes"
'*****************************************************
'Graphical inventory for ORE 0.4.1
'Designed and implemented by Juan Martín Sotuyo Dodero (Maraxus)
'juansotuyo@hotmail.com
'*****************************************************

'**************************************************************************
'This program is free software; you can redistribute it and/or modify
'it under the terms of the GNU General Public License as published by
'the Free Software Foundation; either version 2 of the License, or
'(at your option) any later version.
'
'This program is distributed in the hope that it will be useful,
'but WITHOUT ANY WARRANTY; without even the implied warranty of
'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
'Affero General Public License for more details.
'
'You should have received a copy of the GNU General Public License
'along with this program; if not, write to the Free Software
'Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
'**************************************************************************

Option Explicit

Dim InventoryOffset As Long             'Number of lines we scrolled down from topmost
Dim InvSelectedItem As Long             'Currently selected item

'Dim InvSurface As DirectDrawSurface7            'DD Surface used to render everything

Dim UserInventory(1 To MAX_INVENTORY_SLOTS) As Inventory    'User's inventory

Dim WithEvents InventoryWindow As PictureBox    'Placeholder where to render the inventory
Attribute InventoryWindow.VB_VarHelpID = -1

#If ConMenuesConextuales = 1 Then
    Dim ItemMenu As Menu    'Menu to be shown as pop up
#End If

Dim last_i As Byte
Dim last_s As Byte
Dim invtl(3) As TLVERTEX

Dim slots(1 To 6) As Byte

Public Sub DrawInventory()
    Dim i As Long
    Dim x!
    Dim Y!
    Call SurfaceDB.GetTexture(9719)
    D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, invtl(0), TL_size
    For i = 1 To MAX_INVENTORY_SLOTS
        If UserInventory(i).GrhIndex Then
            x = ((i - 1) Mod 4) * 37 + 5
            Y = ((i - 1) \ 4) * 37 + 5
            
            If InvSelectedItem = i Then
                Call Engine.Draw_FilledBox(x, Y, 32, 32, &H7F000000, &H7FCC0000)
                'Grh_Render_invselslot X, Y
            End If
            
            Call Engine.Grh_Render_nocolor(UserInventory(i).GrhIndex, x, Y)
            If UserInventory(i).Amount > 1 Then Call Engine.Text_Render_ext(CStr(UserInventory(i).Amount), Y, x, 40, 40, &HFFFFFFFF)
            If UserInventory(i).Equipped Then
                Call Engine.Text_Render_ext("+", Y + 20!, x + 20!, 40!, 40!, &HFFFFFF00)
            End If
        End If
    Next i
    For i = 1 To 6
        If slots(i) Then
            Call Engine.Grh_Render_nocolor(UserInventory(slots(i)).GrhIndex, Special_slots_rect(i - 1).Left + 5, Special_slots_rect(i - 1).Top + 5)
        End If
    Next i
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

'Private Declare Sub CopyMemory Lib "Kernel32" Alias "RtlMoveMemory" (ByRef dest As Any, ByRef Source As Any, ByVal byteCount As Long)


Private Sub Class_Initialize()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'
'***************************************************
On Error Resume Next
            frmMain.ImageList1.MaskColor = vbBlack
            frmMain.ImageList1.UseMaskColor = True
            init_gui_tl invtl, 0, 0, 199, 200
End Sub

Private Sub Class_Terminate()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'
'***************************************************
End Sub

Public Sub ScrollInventory(ByVal up As Boolean)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Scrolls the graphical inventory up / down
'***************************************************
    'Only move if there is something to show up /down
    If up Then
        If (InventoryOffset + (148 \ 37)) * (148 \ 37) < MAX_INVENTORY_SLOTS Then _
            InventoryOffset = InventoryOffset + 1
    Else
        If InventoryOffset > 0 Then _
            InventoryOffset = InventoryOffset - 1
    End If
    
    'Redraw the inventory
    DrawInventory
End Sub

Public Sub SelectGold()
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Sets the gold as the currently selected item
'***************************************************
    Dim prevSelectedItem As Long
    
    'Store preivously selected item
    prevSelectedItem = InvSelectedItem
    
    'Select the gold
    InvSelectedItem = FLAGORO
    
    'Redraw old item to deselect it
    If prevSelectedItem <> FLAGORO Then
        Call DrawInventorySlot(prevSelectedItem)
    End If
End Sub

Public Property Get SelectedItem() As Long
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the selected item index
'***************************************************
    SelectedItem = InvSelectedItem
End Property

Public Property Get MaxHit(ByVal slot As Byte) As Integer
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the max hit of the selected item
'***************************************************
    MaxHit = UserInventory(slot).MaxHit
End Property

Public Property Get MinHit(ByVal slot As Byte) As Integer
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the min hit of the selected item
'***************************************************
    MinHit = UserInventory(slot).MinHit
End Property

Public Property Get Def(ByVal slot As Byte) As Integer
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the defense of the selected item
'***************************************************
    Def = UserInventory(slot).Def
End Property

Public Property Get GrhIndex(ByVal slot As Byte) As Integer
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the grh index of the selected item
'***************************************************
    GrhIndex = UserInventory(slot).GrhIndex
End Property

Public Property Get flags(ByVal slot As Byte) As Single
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the value of the selected item
'***************************************************
    flags = UserInventory(slot).flags
End Property

Public Property Get Amount(ByVal slot As Byte) As Long
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the selected item's amount
'***************************************************
    If slot = FLAGORO Then
        Amount = UserGLD
    ElseIf slot >= LBound(UserInventory) And slot <= UBound(UserInventory) Then
        Amount = UserInventory(slot).Amount
    End If
End Property

Public Property Get OBJIndex(ByVal slot As Byte) As Integer
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the selected item's object index
'***************************************************
    OBJIndex = UserInventory(slot).OBJIndex
End Property

Public Property Get OBJType(ByVal slot As Byte) As Integer
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the selected item's object type
'***************************************************
    OBJType = UserInventory(slot).OBJType
End Property

Public Property Get ItemName(ByVal slot As Byte) As String
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves the selected item's name
'***************************************************
    ItemName = UserInventory(slot).name
End Property

Public Property Get Equipped(ByVal slot As Byte) As Boolean
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Retrieves True if the item at the given pos is eqiupped
'***************************************************
    Equipped = UserInventory(slot).Equipped
End Property

Public Sub SetItem(ByVal slot As Byte, ByVal eOBJIndex As Integer, ByVal eAmount As Integer, ByVal eEquipped As Byte, _
                        ByVal eGrhIndex As Integer, ByVal eObjType As Integer, ByVal eMaxHit As Integer, ByVal eMinHit As Integer, _
                        ByVal eDef As Integer, ByVal flags As Long, ByVal eName As String)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 12/04/06
'Sets all data for a given inventory slot
'***************************************************
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
        .flags = flags
    End With
    
    'Render inventory slot (we don't need to render the whole inventory)
    'Call DrawInventorySlot(slot)

End Sub

Private Function ClickItem(ByVal x As Long, ByVal Y As Long) As Long
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Selects the item clicked if it's valid and return's it's index
'***************************************************
    Dim TempItem As Long
    Dim temp_x As Long
    Dim temp_y As Long
    
    temp_x = x \ 37
    temp_y = Y \ 37
    
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

Public Sub DrawInventorySlot(ByVal slot As Integer)

End Sub

    Public Sub Initialize(ByRef InvPic As PictureBox)

'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Sets the reference to the picture box on which to render the inventory
'***************************************************
    Set InventoryWindow = InvPic
    
    'Make sure auto-redraw is set to true
    InventoryWindow.AutoRedraw = True
    
    'Set apropiate scale (pixel)
    InventoryWindow.ScaleMode = 3
    
    InvSelectedItem = ClickItem(1, 1)   'If there is anything there we select the top left item
    
End Sub

Function buscari(gh As Integer) As Integer
Dim i As Integer
'BUSQUEDA BINARIA?
' LAS PELOTAS
' PAJA
For i = 1 To frmMain.ImageList1.ListImages.count
    If frmMain.ImageList1.ListImages(i).key = "g" & CStr(gh) Then
        buscari = i
        Exit For
    End If
Next i
End Function

Private Sub InventoryWindow_MouseDown(button As Integer, Shift As Integer, x As Single, Y As Single)
    Dim temp_x As Integer
    Dim temp_y As Integer
    Dim TempItem As Integer
    Dim tss As Integer
    'Exit if it got outside the control's area
    click_sslot x, Y, TempItem, tss
    If x < 0 Or Y < 0 Or x > 149 Or Y > 149 Then
        If tss > 0 Then
        
        End If
    Else
        If UserInventory(TempItem).GrhIndex > 0 Then
            frmMain.picInv.MousePointer = vbCustom
            If button = vbRightButton Then
                last_i = TempItem
                If last_i > 0 And last_i < 13 Then
                    Dim poss As Integer
                    poss = buscari(UserInventory(TempItem).GrhIndex)
                    If poss = 0 Then
                         DoEvents
                         frmMain.ImageList1.ListImages.Add , CStr("g" & UserInventory(TempItem).GrhIndex), Picture:=modZLib.Bin_Resource_Load_Picture(CInt(GrhData(UserInventory(TempItem).GrhIndex).FileNum), rGrh) 'General_Load_Picture_From_Resource1(GrhData(UserInventory(TempItem).GrhIndex).FileNum & ".bmp") 'ax
                         poss = frmMain.ImageList1.ListImages.count
                    End If
                    Set InventoryWindow.MouseIcon = frmMain.ImageList1.ListImages(poss).ExtractIcon
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



Private Sub InventoryWindow_MouseMove(button As Integer, Shift As Integer, x As Single, Y As Single)

    Dim temp_x As Integer
    Dim temp_y As Integer
    Dim TempItem As Integer
    
    If x < 0 Or Y < 0 Or x > 200 Or Y > 200 Then _
        Exit Sub
    
    temp_x = x \ 37
    temp_y = Y \ 37
    
    TempItem = temp_x + (temp_y + InventoryOffset) * (148 \ 37) + 1
    If TempItem > MAX_INVENTORY_SLOTS Then TempItem = 1
    
    'If TempItem <= MAX_INVENTORY_SLOTS Then
    '    InventoryWindow.ToolTipText = UserInventory(TempItem).name
    'End If
    If button <> vbRightButton Then InventoryWindow.MousePointer = vbDefault
End Sub

Private Sub InventoryWindow_MouseUp(button As Integer, Shift As Integer, x As Single, Y As Single)
'***************************************************
'Author: Juan Martín Sotuyo Dodero (Maraxus)
'Last Modify Date: 27/07/04
'Implements the mouse up event of the inventory picture box
'Check outs which item was clicked
'***************************************************
    'Store previously selected item
    Dim prevSelItem As Long
        Dim temp_x As Integer
        Dim temp_y As Integer
        Dim TempItem As Integer
        Dim tss As Integer
    'Exit if it got outside the control's area
    
    click_sslot x, Y, TempItem, tss
If x < 0 Or Y < 0 Or x > 149 Or Y > 149 Then
    If tss > 0 And tss < 7 Then
        Protocol.WriteEquipItem last_i
        'If button = vbRightButton And last_i <> Special_slots(tss) Then
        '    Debug.Print tss & "sitem < " & last_i
        'End If
    End If
Else
    prevSelItem = InvSelectedItem

    'Get the currently clickced item
    InvSelectedItem = ClickItem(CInt(x), CInt(Y))
    
    'Update needed inventory slots
    If prevSelItem <> InvSelectedItem Then
        If prevSelItem <> 0 And prevSelItem <> FLAGORO Then Call DrawInventorySlot(prevSelItem)
        If InvSelectedItem Then Call DrawInventorySlot(InvSelectedItem)
    End If
    
    If button = vbRightButton And last_i <> TempItem Then
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
    If button = vbRightButton And prevSelItem = InvSelectedItem Then
        'Show the provided menu as a popup
        Call InventoryWindow.Parent.PopupMenu(ItemMenu, , x, Y)
    End If
#End If
End Sub

Private Sub click_sslot(x!, Y!, ByRef Item%, Optional ByRef sslot%)
Dim i%
Item = (x + 4) \ 37 + ((Y + 4) \ 37) * (148 \ 37) + 1

For i = 0 To 5
    If Collision_sRect(x, Y, Special_slots_rect(i)) Then
        sslot = i + 1
        Exit For
    End If
Next i
If Item > MAX_INVENTORY_SLOTS Then Item = MAX_INVENTORY_SLOTS
End Sub
