VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "clsScriptEngine"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'*****************************************************************
'clsScriptEngine.cls - Microsoft Script Control Wrapper - v1.0.0
'
'Interface to the msscript.ocx that buffers commands for later
'execution.
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

'***************************
'Required Externals
'***************************
'Reference to msscript.ocx
'   - URL: http://msdn.microsoft.com/scripting
'***************************
Option Explicit

Private command_list As clsList
Private WithEvents script_control As ScriptControl
Attribute script_control.VB_VarHelpID = -1

Private Sub Class_Initialize()
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'
'*****************************************************************
    Set script_control = New ScriptControl
    script_control.Language = "VBScript"
End Sub

Private Sub Class_Terminate()
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'
'*****************************************************************
    Deinitialize
    Set script_control = Nothing
End Sub

Public Function Initialize(Optional ByVal allow_ui As Boolean = False) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'
'*****************************************************************
On Error GoTo ErrorHandler:

    script_control.AllowUI = allow_ui
    Set command_list = New clsList

    Initialize = True
    
Exit Function
ErrorHandler:
    If script_control.Error.Description = "" Then
        Log_Event "clsScriptEngine", "Initialize", "Unhandled Error - Number:" & Err.Number & " - Description: " & Err.Description
    Else
        Log_Event "clsScriptEngine", "Initialize", "Script Error - Number: " & script_control.Error.Number & " - Description: " & script_control.Error.Description & " - Line: " & script_control.Error.Line & " - Text: " & LTrim(RTrim(script_control.Error.text))
        script_control.Error.Clear
    End If
End Function

Public Function Deinitialize() As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'
'*****************************************************************
On Error GoTo ErrorHandler:
 
    script_control.Reset
    Set command_list = Nothing
    
    Deinitialize = True
    
Exit Function
ErrorHandler:
    If script_control.Error.Description = "" Then
        Log_Event "clsScriptEngine", "Deinitialize", "Unhandled Error - Number:" & Err.Number & " - Description: " & Err.Description
    Else
        Log_Event "clsScriptEngine", "Deinitialize", "Script Error - Number: " & script_control.Error.Number & " - Description: " & script_control.Error.Description & " - Line: " & script_control.Error.Line & " - Text: " & LTrim(RTrim(script_control.Error.text))
        script_control.Error.Clear
    End If
End Function

Public Function Load_From_File(ByVal script_path As String) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'Load a script from file
'*****************************************************************
On Error GoTo ErrorHandler:
    If General_File_Exists(script_path, vbNormal) Then
        'Read file in
        Dim temp_byte As Byte
        Dim string_buffer As String
        Open script_path For Binary As #1
        Do Until EOF(1)
            Get #1, , temp_byte
            string_buffer = string_buffer & Chr$(temp_byte)
        Loop
        Close #1
        
        'Add to script engine
        script_control.AddCode string_buffer
    Else
        Log_Event "clsScriptEngine", "Load_From_File", "Error - Description: " & "Script path not found. " & script_path
    End If
    
    Load_From_File = True
    
Exit Function
ErrorHandler:
    If script_control.Error.Description = "" Then
        Log_Event "clsScriptEngine", "Load_From_File", "Unhandled Error - Number:" & Err.Number & " - Description: " & Err.Description
    Else
        Log_Event "clsScriptEngine", "Load_From_File", "Script Error - Number: " & script_control.Error.Number & " - Description: " & script_control.Error.Description & " - Line: " & script_control.Error.Line & " - Text: " & LTrim(RTrim(script_control.Error.text))
        script_control.Error.Clear
    End If
End Function

Public Function Command_Add(ByRef s_command As clsScriptCommand) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'Add command to the buffer
'*****************************************************************
    If Check_For_Procedure(s_command.ProcedureName) Then
        command_list.Add s_command
        Command_Add = True
    End If
End Function

Public Function Check_For_Procedure(ByVal procedure_name As String) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'Check to see if a procedure is loaded in the script engine
'*****************************************************************
On Error GoTo ErrorHandler:

    Dim x As Procedure
    For Each x In script_control.Procedures
        If UCase$(x.Name) = UCase$(procedure_name) Then
            Check_For_Procedure = True
            Exit Function
        End If
    Next
    
Exit Function
ErrorHandler:
    If script_control.Error.Description = "" Then
        Log_Event "clsScriptEngine", "Check_For_Procedure", "Unhandled Error - Number:" & Err.Number & " - Description: " & Err.Description
    Else
        Log_Event "clsScriptEngine", "Check_For_Procedure", "Script Error - Number: " & script_control.Error.Number & " - Description: " & script_control.Error.Description & " - Line: " & script_control.Error.Line & " - Text: " & LTrim(RTrim(script_control.Error.text))
        script_control.Error.Clear
    End If
End Function

Public Function Run_All() As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'Run all commands in buffer
'*****************************************************************
    Dim loopc As Long
    Dim command As clsScriptCommand
    Dim parameters() As Variant
        
    Run_All = True
    
    For loopc = 1 To command_list.UpperBound
        Set command = command_list.Item(loopc)
        If Not (command Is Nothing) Then
            command.Parameter_Get_All parameters
            If UBound(parameters) > 0 Then
                If Execute_With_Parameters(command.ProcedureName, parameters) = False Then Run_All = False
            Else
                If Execute(command.ProcedureName) Then Run_All = False
            End If
            command_list.Remove_Index loopc
        End If
        Set command = Nothing
    Next
End Function

Private Function Execute(ByVal procedure_name As String) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'Execute a procedure
'*****************************************************************
On Error GoTo ErrorHandler:

    script_control.Run procedure_name
    Execute = True
    
Exit Function
ErrorHandler:
    If script_control.Error.Description = "" Then
        Log_Event "clsScriptEngine", "Execute", "Unhandled Error - Number:" & Err.Number & " - Description: " & Err.Description
    Else
        Log_Event "clsScriptEngine", "Execute", "Script Error - Number: " & script_control.Error.Number & " - Description: " & script_control.Error.Description & " - Line: " & script_control.Error.Line & " - Text: " & LTrim(RTrim(script_control.Error.text))
        script_control.Error.Clear
    End If
End Function

Private Function Execute_With_Parameters(ByVal procedure_name As String, ByRef parameters() As Variant) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'Execute a procedure with parameters
'*****************************************************************
On Error GoTo ErrorHandler:

    If UBound(parameters) > 1 Then
        script_control.Run procedure_name, parameters()
    Else
        script_control.Run procedure_name, parameters(1)
    End If
    Execute_With_Parameters = True
    
Exit Function
ErrorHandler:
    If script_control.Error.Description = "" Then
        Log_Event "clsScriptEngine", "Execute_With_Parameters", "Unhandled Error - Number:" & Err.Number & " - Description: " & Err.Description
    Else
        Log_Event "clsScriptEngine", "Execute_With_Parameters", "Script Error - Number: " & script_control.Error.Number & " - Description: " & script_control.Error.Description & " - Line: " & script_control.Error.Line & " - Text: " & LTrim(RTrim(script_control.Error.text))
        script_control.Error.Clear
    End If
End Function

Public Function Object_Add(ByVal object_name As String, ByRef object As Object) As Boolean
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'Add a outside referable object to the engine
'*****************************************************************
On Error GoTo ErrorHandler:

    script_control.AddObject object_name, object
    
    Object_Add = True
    
Exit Function
ErrorHandler:
    If script_control.Error.Description = "" Then
        Log_Event "clsScriptEngine", "Object_Add", "Unhandled Error - Number:" & Err.Number & " - Description: " & Err.Description
    Else
        Log_Event "clsScriptEngine", "Object_Add", "Script Error - Number: " & script_control.Error.Number & " - Description: " & script_control.Error.Description & " - Line: " & script_control.Error.Line & " - Text: " & LTrim(RTrim(script_control.Error.text))
        script_control.Error.Clear
    End If
End Function

Private Sub Script_Timeout()
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'
'*****************************************************************
    Log_Event "clsScriptEngine", "Script_Timeout", "Script Error - Number: " & script_control.Error.Number & " - Description: " & script_control.Error.Description & " - Line: " & script_control.Error.Line & " - Text: " & LTrim(RTrim(script_control.Error.text))
    script_control.Error.Clear
End Sub

Public Sub Log_Event(ByVal source_class As String, ByVal source_procedure As String, ByVal event_string As String)
'*****************************************************************
'Author: Aaron Perkins
'Last Modify Date: 5/05/2003
'
'*****************************************************************
    Open App.Path & "\log_script_engine.txt" For Append As #40
    Print #40, CStr(DateTime.Now) & " - " & source_class & " - " & source_procedure & " - " & event_string
    Close #40
End Sub
