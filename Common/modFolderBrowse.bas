Attribute VB_Name = "modFolderBrowse"
Option Explicit

Private Declare Function SHBrowseForFolder Lib "shell32" (lpbi As BrowseInfo) As Long
Private Declare Function SHGetPathFromIDList Lib "shell32" (ByVal pidList As Long, ByVal lpBuffer As String) As Long

Private Declare Function SendMessage Lib "user32.dll" Alias "SendMessageA" (ByVal hWnd As Long, ByVal Msg As Long, wParam As Any, lparam As Any) As Long
Private Declare Sub CoTaskMemFree Lib "ole32.dll" (ByVal pv As Long)

'BrowseInfo ulFlags
Public Const BIF_RETURNONLYFSDIRS = &H1        'Only return file system directories.
Public Const BIF_DONTGOBELOWDOMAIN = &H2       'Do not include network folders below the domain level in the dialog box's tree view control.
Public Const BIF_STATUSTEXT = &H4              'Include a status area in the dialog box.
Public Const BIF_RETURNFSANCESTORS = &H8       'Only return file system ancestors. An ancestor is a subfolder that is beneath the root folder in the namespace hierarchy.
Public Const BIF_EDITBOX = &H10                '(SHELL32.DLL Version 4.71). Include an edit control in the browse dialog box that allows the user to type the name of an item.
Public Const BIF_VALIDATE = &H20               '(SHELL32.DLL Version 4.71). If the user types an invalid name into the edit box, the browse dialog will call the application's BrowseCallbackProc with the BFFM_VALIDATEFAILED message.
Public Const BIF_USENEWUI = &H40               '(SHELL32.DLL Version 5.0). Use the new user interface, including an edit box.
Public Const BIF_NEWDIALOGSTYLE = &H50         '(SHELL32.DLL Version 5.0). Use the new user interface.
Public Const BIF_BROWSEINCLUDEURLS = &H80      '(SHELL32.DLL Version 5.0). The browse dialog box can display URLs. The BIF_USENEWUI and BIF_BROWSEINCLUDEFILES flags must also be set.
Public Const BIF_BROWSEFORCOMPUTER = &H1000    'Only return computers.
Public Const BIF_BROWSEFORPRINTER = &H2000     'Only return network printers.
Public Const BIF_BROWSEINCLUDEFILES = &H4000   '(SHELL32.DLL Version 4.71). The browse dialog will display files as well as folders.
Public Const BIF_SHAREABLE = &H8000            '(SHELL32.DLL Version 5.0). The browse dialog box can display shareable resources on remote systems. The BIF_USENEWUI flag must also be set.

'BrowseInfo pIDLRoot(Do not use these with new style dialog)
Const default = 0
Const Internet = 1
Const Programs = 2
Const ControlPanel = 3
Const Printers = 4
Const MyDocuments = 5
Const Favorites = 6
Const StartUp = 7
Const Recent = 8
Const SendTo = 9
Const RecycleBin = 10
Const StartMenu = 11
Const Desktop = 16
Const MyComputer = 17
Const Network = 18
Const Nethood = 19
Const Fonts = 20
Const Templates = 21
Const ApplicationData = 26
Const PrintHood = 27
Const TemporaryInternetFiles = 32
Const Cookies = 33
Const History = 34

Const BFFM_ENABLEOK = &H465
Const BFFM_SETSELECTION = &H466
Const BFFM_SETSTATUSTEXT = &H464

Const BFFM_INITIALIZED = 1
Const BFFM_SELCHANGED = 2
Const BFFM_VALIDATEFAILED = 3

Const MAX_PATH = 260

Type BrowseInfo
    hWndOwner As Long
    pIDLRoot As Long
    pszDisplayName As String
    lpszTitle As String
    ulFlags As Long
    lpfnCallBack As Long
    lparam As Long
    iImage As Integer
End Type


Public StartFolder As String
Public SpecialFolder As Long
Public CurrentSelection As String * MAX_PATH
Public OKEnable As Boolean
Public szDisplay As String
Public hWndText As Long

Private Declare Function GetWindow Lib "user32" (ByVal hWnd As Long, ByVal wCmd As Long) As Long
Private Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hWnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long
Private Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hWnd As Long, ByVal lpString As String, ByVal cch As Long) As Long

Private Const GW_HWNDNEXT = 2
Private Const GW_CHILD = 5


Private Type OPENFILENAME

    lStructSize As Long
    hWndOwner As Long
    hInstance As Long
    lpstrFilter As String
    lpstrCustomFilter As String
    nMaxCustFilter As Long
    nFilterIndex As Long
    lpstrFile As String
    nMaxFile As Long
    lpstrFileTitle As String
    nMaxFileTitle As Long
    lpstrInitialDir As String
    lpstrTitle As String
    flags As Long
    nFileOffset As Integer
    nFileExtension As Integer
    lpstrDefExt As String
    lCustData As Long
    lpfnHook As Long
    lpTemplateName As String
End Type
Public Const OFN_READONLY = &H1
Public Const OFN_OVERWRITEPROMPT = &H2
Public Const OFN_HIDEREADONLY = &H4
Public Const OFN_NOCHANGEDIR = &H8
Public Const OFN_SHOWHELP = &H10
Public Const OFN_ENABLEHOOK = &H20
Public Const OFN_ENABLETEMPLATE = &H40
Public Const OFN_ENABLETEMPLATEHANDLE = &H80
Public Const OFN_NOVALIDATE = &H100
Public Const OFN_ALLOWMULTISELECT = &H200
Public Const OFN_EXTENSIONDIFFERENT = &H400
Public Const OFN_PATHMUSTEXIST = &H800
Public Const OFN_FILEMUSTEXIST = &H1000
Public Const OFN_CREATEPROMPT = &H2000
Public Const OFN_SHAREAWARE = &H4000
Public Const OFN_NOREADONLYRETURN = &H8000
Public Const OFN_NOTESTFILECREATE = &H10000
Public Const OFN_NONETWORKBUTTON = &H20000
Public Const OFN_NOLONGNAMES = &H40000 ' force no long names for 4.x modules
Public Const OFN_EXPLORER = &H80000 ' new look commdlg
Public Const OFN_NODEREFERENCELINKS = &H100000
Public Const OFN_LONGNAMES = &H200000 ' force long names for 3.x modules
Public Const OFN_SHAREFALLTHROUGH = 2
Public Const OFN_SHARENOWARN = 1
Public Const OFN_SHAREWARN = 0
'Folder



Public Const WM_USER = &H400
Public Const LPTR = (&H0 Or &H40)
Public Const BFFM_SETSELECTIONA As Long = (WM_USER + 102)
Public Const BFFM_SETSELECTIONW As Long = (WM_USER + 103)

Private Declare Function LocalAlloc Lib "kernel32" (ByVal uFlags As Long, ByVal uBytes As Long) As Long
Private Declare Function LocalFree Lib "kernel32" (ByVal hMem As Long) As Long
'Open/Save
Private Declare Function GetSaveFileName Lib "comdlg32" Alias "GetSaveFileNameA" (pOpenfilename As OPENFILENAME) As Long
Private Declare Function GetOpenFileName Lib "comdlg32" Alias "GetOpenFileNameA" (pOpenfilename As OPENFILENAME) As Long

Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (pDest As Any, pSource As Any, ByVal dwLength As Long)


Private Function BrowseCallbackProcStr(ByVal hWnd As Long, ByVal uMsg As Long, ByVal lparam As Long, ByVal lpData As Long) As Long

    If uMsg = 1 Then
        Call SendMessage(hWnd, BFFM_SETSELECTIONA, True, ByVal lpData)
    End If

End Function

Public Function BrowseForFolder(strTitle As String, lngHwnd As Long, Optional strInitialDirectory As String) As String

  Dim Browse_for_folder As BrowseInfo
  Dim lngItemID As Long
  Dim lngInitDirPointer As Long
  Dim strTempPath As String * 256

    If strInitialDirectory = "" Then strInitialDirectory = app.Path

    With Browse_for_folder
        .hWndOwner = lngHwnd 'Window Handle
        .lpszTitle = strTitle 'Dialog Title
        .lpfnCallBack = FunctionPointer(AddressOf BrowseCallbackProcStr) 'Dialog callback function that preselectes the folder specified
        lngInitDirPointer = LocalAlloc(LPTR, Len(strInitialDirectory) + 1) 'Allocate a string
        Call CopyMemory(ByVal lngInitDirPointer, ByVal strInitialDirectory, Len(strInitialDirectory) + 1) 'Copy the path to the string
        .lparam = lngInitDirPointer  'The folder to preselect
    End With

    lngItemID = SHBrowseForFolder(Browse_for_folder) 'Execute the BrowseForFolder API

    If lngItemID Then
        If SHGetPathFromIDList(lngItemID, strTempPath) Then ' Get the path for the selected folder in the dialog
            BrowseForFolder = Left$(strTempPath, InStr(strTempPath, vbNullChar) - 1) ' Take only the path without the nulls
        End If

        Call CoTaskMemFree(lngItemID) 'Free the lngItemID
    End If

    Call LocalFree(lngInitDirPointer) 'Free the string from the memory

End Function

Private Function FunctionPointer(FunctionAddress As Long) As Long

    FunctionPointer = FunctionAddress

End Function

'"JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg|CompuServe GIF (*.gif)|*.gif"
Public Function OpenDialog(strFilter As String, strTitle As String, strDefaultExtension As String, strInitialDirectory As String, lngHwnd As Long) As String

    On Error GoTo Problems
  Dim OpenFile As OPENFILENAME
  Dim strTemp As String
  Dim intNull As Integer

    If Right$(strFilter, 1) <> Chr$(0) Then strFilter = strFilter & Chr$(0)
    strFilter = Replace(strFilter, "|", Chr$(0))

    OpenFile.lStructSize = Len(OpenFile)
    OpenFile.hWndOwner = lngHwnd
    OpenFile.lpstrInitialDir = strInitialDirectory
    OpenFile.hInstance = app.hInstance
    OpenFile.lpstrFilter = strFilter
    OpenFile.nFilterIndex = 1
    OpenFile.lpstrFile = String$(257, 0)
    OpenFile.nMaxFile = Len(OpenFile.lpstrFile) - 1
    OpenFile.lpstrFileTitle = OpenFile.lpstrFile
    OpenFile.nMaxFileTitle = OpenFile.nMaxFile
    OpenFile.lpstrTitle = strTitle
    OpenFile.lpstrDefExt = strDefaultExtension
    OpenFile.flags = OFN_HIDEREADONLY

    If GetOpenFileName(OpenFile) = 0 Then
        OpenDialog = ""
      Else
        strTemp = OpenFile.lpstrFile
        intNull = InStr(1, strTemp, Chr$(0))
        OpenDialog = Mid$(strTemp, 1, intNull - 1)
    End If

Exit Function

Problems:
    MsgBox Err.Description, 16, "Error " & Err.number

End Function

Public Function SaveDialog(strFilter As String, strTitle As String, strInitialDirectory As String, lngHwnd As Long, Optional strFileName As String) As String

  Dim OpenFile As OPENFILENAME
  Dim strExtension As String

    OpenFile.lStructSize = Len(OpenFile)
    OpenFile.hWndOwner = lngHwnd
    OpenFile.hInstance = app.hInstance
    If Right$(strFilter, 1) <> "|" Then strFilter = strFilter + "|"

    strFilter = Replace(strFilter, "|", Chr$(0))
    If strFileName = "" Then strFileName = Space$(254) Else strFileName = strFileName & Space$(254 - Len(strFileName))

    OpenFile.lpstrFilter = strFilter
    OpenFile.lpstrFile = strFileName
    OpenFile.nMaxFile = 255
    OpenFile.lpstrFileTitle = Space$(254)
    OpenFile.nMaxFileTitle = 255
    OpenFile.lpstrInitialDir = strInitialDirectory
    OpenFile.lpstrTitle = strTitle
    OpenFile.flags = OFN_HIDEREADONLY Or OFN_OVERWRITEPROMPT Or OFN_CREATEPROMPT

    If GetSaveFileName(OpenFile) Then
        SaveDialog = Trim$(OpenFile.lpstrFile)
        strExtension = Mid$(Right$(strFilter, 5), 1, 4)
        strFileName = Left$(SaveDialog, Len(SaveDialog) - 1)
        If Right$(strFileName, 4) = strExtension Then strExtension = ""
        SaveDialog = strFileName & strExtension
        If strFilter = "*.*" & Chr$(0) Then SaveDialog = strFileName
      Else
        SaveDialog = ""
    End If

End Function

Public Function MakeDirectory(szDirectory As String) As Boolean

Dim strFolder As String
Dim szRslt As String

On Error GoTo IllegalFolderName

If Right(szDirectory, 1) <> "\" Then szDirectory = szDirectory & "\"

strFolder = szDirectory

szRslt = Dir(strFolder, 63)

While szRslt = ""
    DoEvents
    szRslt = Dir(strFolder, 63)
    strFolder = Left(strFolder, Len(strFolder) - 1)
    If strFolder = "" Then GoTo IllegalFolderName
Wend

If Right(strFolder, 1) <> "\" Then strFolder = strFolder & "\"

While strFolder <> szDirectory
    strFolder = Left(szDirectory, Len(strFolder) + 1)
    If Right(strFolder, 1) = "\" Then MkDir strFolder
Wend

MakeDirectory = True

Exit Function

IllegalFolderName:
    Call MsgBox("Could not Create Destination Folder.", vbExclamation)
    
End Function

Public Function GetText(hWnd As Long) As String

Dim hWndChild  As Long, nSize As Long
Dim sBuffer As String * 32
Dim lmsg As String * 260
hWndChild = GetWindow(hWnd, GW_CHILD)
   
Do While hWndChild <> 0

    nSize = GetClassName(hWndChild, sBuffer, 32)
       
    If nSize Then
        If Left$(sBuffer, nSize) = "Edit" Then
            lmsg = Space(64)
            Call GetWindowText(hWndChild, lmsg, 260)
            GetText = Left(lmsg, InStr(lmsg, vbNullChar) - 1)
            Exit Function
        End If
    End If
      
    hWndChild = GetWindow(hWndChild, GW_HWNDNEXT)
       
Loop

End Function


Public Function FolderBrowse(hwndForm As Long, szInstruction As String, Optional lFlags As Long, Optional ByVal StartFolders As String) As String

    Dim BI As BrowseInfo
    Dim lRslt As Long
    Dim strReturn As String
StartFolder = StartFolders
    With BI
        .hWndOwner = hwndForm
        
        .lpszTitle = szInstruction
        .pIDLRoot = SpecialFolder
        .ulFlags = lFlags + BIF_VALIDATE
        .pszDisplayName = String$(MAX_PATH, 0)
        .lpfnCallBack = DummyFunction(AddressOf BrowseCallbackProc)
    End With

    lRslt = SHBrowseForFolder(BI)

    If lRslt Then
        lRslt = SHGetPathFromIDList(lRslt, CurrentSelection)
        strReturn = Left(CurrentSelection, InStr(CurrentSelection, vbNullChar) - 1)
        szDisplay = Left$(BI.pszDisplayName, InStr(BI.pszDisplayName, vbNullChar) - 1)
    End If
    
    If Right$(strReturn, 1) <> "\" Then strReturn = strReturn & "\"
    FolderBrowse = strReturn
    If FolderBrowse = "\" Then FolderBrowse = StartFolder
StartFolder = ""
    CoTaskMemFree (lRslt)

End Function

Public Function BrowseCallbackProc(ByVal hWnd As Long, ByVal uMsg As Long, ByVal lparam As Long, ByVal lpData As Long) As Long
    
    On Error Resume Next
    
    Dim retVal As Long

    Select Case uMsg
        Case BFFM_INITIALIZED
            If StartFolder > "" Then Call SendMessage(hWnd, BFFM_SETSELECTION, 0, ByVal StartFolder)
        
        Case BFFM_SELCHANGED
            retVal = SHGetPathFromIDList(lparam, CurrentSelection)
            If retVal <> 0 Then
                Call SendMessage(hWnd, BFFM_SETSTATUSTEXT, 0, ByVal CurrentSelection)
            End If

            If SpecialFolder = 4 Then Call SendMessage(hWnd, BFFM_ENABLEOK, 0, ByVal True)
            If Not OKEnable Then Call SendMessage(hWnd, BFFM_ENABLEOK, 0, ByVal OKEnable)

            CoTaskMemFree (retVal)

        Case BFFM_VALIDATEFAILED
            If MsgBox("The Path You Typed Does Not Exist!" & vbCrLf _
                    & "Would you like to create it?", vbYesNo Or vbQuestion) = vbYes Then
                szDisplay = GetText(hWnd)
                If szDisplay > "" Then
                    MakeDirectory (szDisplay)
                    Call SendMessage(hWnd, BFFM_SETSELECTION, 0, ByVal szDisplay)
                    BrowseCallbackProc = 1
                    Exit Function
                End If
            Else
                BrowseCallbackProc = 1
                Exit Function
            End If
    End Select

    BrowseCallbackProc = 0

End Function

Public Function DummyFunction(ByVal lparam As Long) As Long
    DummyFunction = lparam
End Function




