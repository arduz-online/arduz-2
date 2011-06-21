VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsScriptInterface"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'*****************************************************************
'clsScriptInterface.cls - ORE Script Interface Object - v0.5.0
'
'Methods and properties in this class are exposed tot he script
'engine and can be execute by scripts.
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
'Contributors History
'   When releasing modifications to this source file please add your
'   date of release, name, email, and any info to the top of this list.
'   Follow this template:
'    XX/XX/200X - Your Name Here (Your Email Here)
'       - Your Description Here
'       Sub Release Contributors:
'           XX/XX/2003 - Sub Contributor Name Here (SC Email Here)
'               - SC Description Here
'*****************************************************************
'
'Aaron Perkins(aaron@baronsoft.com) - 8/04/2003
'   - First Release
'*****************************************************************
Option Explicit

Private dps As ctlDirectPlayServer
Private script_engine As clsScriptEngine
Private map_list As clsList
Private player_list As clsList
Private npc_list As clsList
Private char_list As clsList

Private Sub Class_Initialize()
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
End Sub

Private Sub Class_Terminate()
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    Deinitialize
End Sub

Public Function Initialize(ByRef s_dps As ctlDirectPlayServer, ByRef s_script_engine As clsScriptEngine, ByRef s_map_list As clsList, ByRef s_player_list As clsList, ByRef s_npc_list As clsList, ByRef s_char_list As clsList) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    Set dps = s_dps
    Set script_engine = s_script_engine
    Set map_list = s_map_list
    Set player_list = s_player_list
    Set npc_list = s_npc_list
    Set char_list = s_char_list
    Initialize = True
End Function

Public Function Deinitialize() As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    Deinitialize = True
End Function

Public Function Random_Number(lower_bound As Long, upper_bound As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    Random_Number = CLng(General_Random_Number(lower_bound, upper_bound))
End Function

Public Sub Debug_Print(ByVal debug_string As Variant)
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    Debug.Print debug_string
End Sub

Public Sub Chat_To_All(ByVal message_string As String)
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    'Send Chat Packet
    If dps.Chat_To_All(CStr(message_string)) = False Then
        dps.Log_Event "clsScriptInterface", "Chat_To_All", "Error - Failed to send."
    End If
End Sub

Public Sub Chat_To_Player(ByVal player_id As String, ByVal message_string As String)
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    'Send Chat Packet
    If dps.Chat_To_Player(CLng(player_id), CStr(message_string)) = False Then
        dps.Log_Event "clsScriptInterface", "Chat_To_Player", "Error - Failed to send to player_id: " & CStr(player_id)
        Exit Sub
    End If
End Sub

Public Sub Chat_To_Map(ByVal s_map_name As String, ByVal message_string As String)
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    'Send Chat Packet
    If dps.Chat_To_Map_Name(CStr(s_map_name), CStr(message_string)) = False Then
        dps.Log_Event "clsScriptInterface", "Chat_To_Map", "Error - Failed to send to map_name: " & CStr(s_map_name)
        Exit Sub
    End If
End Sub

Public Function Server_Session_Create(ByVal player_id As Long, ByVal s_session_name As String, ByVal s_session_data As Variant, ByVal s_session_save As Boolean) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    Server_Session_Create = dps.Session_Variable_Create(s_session_name, s_session_data, s_session_save)
End Function

Public Function Server_Session_Check(ByVal s_session_name As String) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    Server_Session_Check = dps.Session_Variable_Check(s_session_name)
End Function

Public Function Server_Session_Get(ByVal s_session_name As String) As Variant
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    Server_Session_Get = dps.Session_Variable_Get(s_session_name)
End Function

Public Function Server_Session_Set(ByVal s_session_name As String, ByVal s_session_data As Variant) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    Server_Session_Set = dps.Session_Variable_Set(s_session_name, s_session_data)
End Function

Public Function Map_Find_Nearest_Player(ByVal s_map_name, ByVal s_map_x As Long, ByVal s_map_y As Long, ByVal s_scan_range As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get map object
    Dim map As clsMap
    Set map = map_list.Find("Name", s_map_name)
    If map Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Map_Find_Nearest_Player", "Error - Map name does not exist: " & CStr(s_map_name)
        Exit Function
    End If

    Map_Find_Nearest_Player = map.Grid_Find_Nearest_Player(s_map_x, s_map_y, s_scan_range)
End Function

Public Function Player_Session_Create(ByVal player_id As Long, ByVal s_session_name As String, ByVal s_session_data As Variant, ByVal s_session_save As Boolean) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Session_Create", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If
    
    Player_Session_Create = player.Session_Variable_Create(s_session_name, s_session_data, s_session_save)
End Function

Public Function Player_Session_Check(ByVal player_id As Long, ByVal s_session_name As String) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Session_Check", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If
    
    Player_Session_Check = player.Session_Variable_Check(s_session_name)
End Function

Public Function Player_Session_Get(ByVal player_id As Long, ByVal s_session_name As String) As Variant
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Session_Get", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If
    
    Player_Session_Get = player.Session_Variable_Get(s_session_name)
End Function

Public Function Player_Session_Set(ByVal player_id As Long, ByVal s_session_name As String, ByVal s_session_data As Variant) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Session_Set", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If
    
    Player_Session_Set = player.Session_Variable_Set(s_session_name, s_session_data)
End Function

Public Function Player_Name_Get(ByVal player_id As Long) As String
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Name_Get", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If

    Player_Name_Get = player.Name
End Function

Public Function Player_Map_Name_Get(ByVal player_id As Long) As String
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Map_Name_Get", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If
    'Get map object
    Dim map As clsMap
    Set map = map_list.Item(player.MapID)
    If map Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Map_Name_Get", "Error - Player does not have a valid map id: " & CStr(player_id)
        Exit Function
    End If

    Player_Map_Name_Get = map.Name
End Function

Public Function Player_Map_X_Get(ByVal player_id As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Map_X_Get", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If

    Player_Map_X_Get = player.MapX
End Function

Public Function Player_Map_Y_Get(ByVal player_id As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Map_Y_Get", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If

    Player_Map_Y_Get = player.MapY
End Function

Public Function Player_Heading_Get(ByVal player_id As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Heading_Get", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If

    Player_Heading_Get = player.Heading
End Function

Public Function Player_Heading_Set(ByVal player_id As Long, ByVal s_heading As Long) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Heading_Set", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If

    player.Heading = s_heading
    Player_Heading_Set = True
End Function

Public Function Player_Position_Set(ByVal player_id As Long, ByVal s_map_name As String, ByVal s_map_x As Long, ByVal s_map_y As Long) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/6/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Position_Set", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If
    'Get map object
    Dim map As clsMap
    Set map = map_list.Find("Name", s_map_name)
    If map Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Position_Set", "Error - Map name does not exist: " & CStr(s_map_name)
        Exit Function
    End If

    'Set Player Pos
    Player_Position_Set = player.Position_Set(map.ID, s_map_x, s_map_y)
End Function

Public Function Player_Move_By_Heading(ByVal player_id As Long, ByVal s_heading As Long) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get player object
    Dim player As clsPlayer
    Set player = player_list.Item(player_id)
    If player Is Nothing Then
        dps.Log_Event "clsScriptInterface", "Player_Move_By_Heading", "Error - Player ID does not exist: " & CStr(player_id)
        Exit Function
    End If

    Player_Move_By_Heading = player.Move_By_Heading(s_heading)
End Function

Public Function NPC_Create(ByVal s_npc_data_index As Long, ByVal s_map_name As String, ByVal s_map_x As Long, ByVal s_map_y As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get map object
    Dim map As clsMap
    Set map = map_list.Find("Name", s_map_name)
    If map Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Create", "Error - Map name does not exist: " & CStr(s_map_name)
        Exit Function
    End If
    
    NPC_Create = dps.NPC_Create(s_npc_data_index, map.ID, s_map_x, s_map_y)
End Function

Public Function NPC_Name_Get(ByVal npc_id As Long) As String
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Name_Get", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If

    NPC_Name_Get = npc.Name
End Function

Public Function NPC_Map_Name_Get(ByVal npc_id As Long) As String
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Map_Name_Get", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If
    'Get map object
    Dim map As clsMap
    Set map = map_list.Item(npc.MapID)
    If map Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Map_Name_Get", "Error - NPC does not have a valid map id: " & CStr(npc_id)
        Exit Function
    End If

    NPC_Map_Name_Get = map.Name
End Function

Public Function NPC_Map_X_Get(ByVal npc_id As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Map_X_Get", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If

    NPC_Map_X_Get = npc.MapX
End Function

Public Function NPC_Map_Y_Get(ByVal npc_id As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Map_Y_Get", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If

    NPC_Map_Y_Get = npc.MapY
End Function

Public Function NPC_Heading_Get(ByVal npc_id As Long) As Long
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Heading_Get", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If

    NPC_Heading_Get = npc.Heading
End Function

Public Function NPC_Heading_Set(ByVal npc_id As Long, ByVal s_heading As Long) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Heading_Set", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If

    npc.Heading = s_heading
    NPC_Heading_Set = True
End Function

Public Function NPC_Move_By_Heading(ByVal npc_id As Long, ByVal s_heading As Long) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Move_By_Heading", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If

    NPC_Move_By_Heading = npc.Move_By_Heading(s_heading)
End Function

Public Function NPC_Session_Create(ByVal npc_id As Long, ByVal s_session_name As String, ByVal s_session_data As Variant) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Session_Create", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If
    
    NPC_Session_Create = npc.Session_Variable_Create(s_session_name, s_session_data)
End Function

Public Function NPC_Session_Check(ByVal npc_id As Long, ByVal s_session_name As String) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Session_Check", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If
    
    NPC_Session_Check = npc.Session_Variable_Check(s_session_name)
End Function

Public Function NPC_Session_Get(ByVal npc_id As Long, ByVal s_session_name As String) As Variant
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Session_Get", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If
    
    NPC_Session_Get = npc.Session_Variable_Get(s_session_name)
End Function

Public Function NPC_Session_Set(ByVal npc_id As Long, ByVal s_session_name As String, ByVal s_session_data As Variant) As Boolean
'**************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/13/2003
'
'**************************************************************
    'Get npc object
    Dim npc As clsNPC
    Set npc = npc_list.Item(npc_id)
    If npc Is Nothing Then
        dps.Log_Event "clsScriptInterface", "NPC_Session_Set", "Error - NPC ID does not exist: " & CStr(npc_id)
        Exit Function
    End If
    
    NPC_Session_Set = npc.Session_Variable_Set(s_session_name, s_session_data)
End Function
