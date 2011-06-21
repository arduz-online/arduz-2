Attribute VB_Name = "modRegistro"


Public Const HKEY_CLASSES_ROOT = &H80000000
Public Const HKEY_CURRENT_USER = &H80000001
Public Const HKEY_LOCAL_MACHINE = &H80000002
Public Const HKEY_USERS = &H80000003
Public Const HKEY_PERFORMANCE_DATA = &H80000004

Public Const ERROR_SUCCESS = 0&
Public Const REG_SZ = 1
Public Const REG_DWORD = 4

Private Const KEY_ALL_ACCESS = &HF003F
Private Const HKEY_DYN_DATA = &H80000006
Private Const REG_BINARY = 3
Private Const REG_DWORD_BIG_ENDIAN = 5
Private Const REG_DWORD_LITTLE_ENDIAN = 4
Private Const REG_EXPAND_SZ = 2
Private Const REG_LINK = 6
Private Const REG_MULTI_SZ = 7
Private Const REG_NONE = 0
Private Const REG_RESOURCE_LIST = 8

Private Declare Function RegCloseKey Lib "advapi32.dll" (ByVal hKey As Long) As Long
Private Declare Function RegCreateKey Lib "advapi32.dll" Alias "RegCreateKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, phkResult As Long) As Long
Private Declare Function RegDeleteKey Lib "advapi32.dll" Alias "RegDeleteKeyA" (ByVal hKey As Long, ByVal lpSubKey As String) As Long
Private Declare Function RegDeleteValue Lib "advapi32.dll" Alias "RegDeleteValueA" (ByVal hKey As Long, ByVal lpValueName As String) As Long
Private Declare Function RegOpenKey Lib "advapi32.dll" Alias "RegOpenKeyA" (ByVal hKey As Long, ByVal lpSubKey As String, phkResult As Long) As Long
Private Declare Function RegQueryValueEx Lib "advapi32.dll" Alias "RegQueryValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal lpReserved As Long, lpType As Long, lpData As Any, lpcbData As Long) As Long
Private Declare Function RegSetValueEx Lib "advapi32.dll" Alias "RegSetValueExA" (ByVal hKey As Long, ByVal lpValueName As String, ByVal Reserved As Long, ByVal dwType As Long, lpData As Any, ByVal cbData As Long) As Long


Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Declare Function LoadLibraryRegister Lib "kernel32" Alias "LoadLibraryA" (ByVal lpLibFileName As String) As Long
  
Private Declare Function CreateThreadForRegister Lib "kernel32" Alias "CreateThread" (lpThreadAttributes As Any, ByVal dwStackSize As Long, ByVal lpStartAddress As Long, ByVal lParameter As Long, ByVal dwCreationFlags As Long, lpThreadID As Long) As Long
   
Private Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
   
Private Declare Function GetProcAddressRegister Lib "kernel32" Alias "GetProcAddress" (ByVal hModule As Long, ByVal lpProcName As String) As Long

Private Declare Function FreeLibraryRegister Lib "kernel32" Alias "FreeLibrary" (ByVal hLibModule As Long) As Long

Private Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

Private Declare Function GetExitCodeThread Lib "kernel32" (ByVal hThread As Long, lpExitCode As Long) As Long

Private Declare Sub ExitThread Lib "kernel32" (ByVal dwExitCode As Long)

Public Function RegServer(ByVal FileName As String) As Boolean
'USAGE: PASS FULL PATH OF ACTIVE .DLL OR
'OCX YOU WANT TO REGISTER
RegServer = RegSvr32(FileName, False)
End Function

Public Function UnRegServer(ByVal FileName As String) As Boolean
'USAGE: PASS FULL PATH OF ACTIVE .DLL OR
'OCX YOU WANT TO UNREGISTER
UnRegServer = RegSvr32(FileName, True)
End Function
    
Private Function RegSvr32(ByVal FileName As String, bUnReg As Boolean) As Boolean

Dim lLib As Long
Dim lProcAddress As Long
Dim lThreadID As Long
Dim lSuccess As Long
Dim lExitCode As Long
Dim lThread As Long
Dim bAns As Boolean
Dim sPurpose As String

sPurpose = IIf(bUnReg, "DllUnregisterServer", _
  "DllRegisterServer")

If Dir(FileName) = "" Then Exit Function

lLib = LoadLibraryRegister(FileName)
'could load file
If lLib = 0 Then Exit Function

lProcAddress = GetProcAddressRegister(lLib, sPurpose)

If lProcAddress = 0 Then
  'Not an ActiveX Component
   FreeLibraryRegister lLib
   Exit Function
Else
   lThread = CreateThreadForRegister(ByVal 0&, 0&, ByVal lProcAddress, ByVal 0&, 0&, lThread)
   If lThread Then
        lSuccess = (WaitForSingleObject(lThread, 10000) = 0)
        If Not lSuccess Then
           Call GetExitCodeThread(lThread, lExitCode)
           Call ExitThread(lExitCode)
           bAns = False
           Exit Function
        Else
           bAns = True
        End If
        CloseHandle lThread
        FreeLibraryRegister lLib
   End If
End If
    RegSvr32 = bAns
End Function




Public Sub SaveKey(hKey As Long, strPath As String)
    Dim keyhand&
    Dim r&
    r = RegCreateKey(hKey, strPath, keyhand&)
    r = RegCloseKey(keyhand&)
End Sub

Public Function GetString(hKey As Long, strPath As String, strvalue As String)
    Dim keyhand As Long
    Dim datatype As Long
    Dim lResult As Long
    Dim strBuf As String
    Dim lDataBufSize As Long
    Dim intZeroPos As Integer
    Dim r&
    r = RegOpenKey(hKey, strPath, keyhand)
    lResult = RegQueryValueEx(keyhand, strvalue, 0&, lValueType, ByVal 0&, lDataBufSize)
    If lValueType = REG_SZ Then
        strBuf = String(lDataBufSize, " ")
        lResult = RegQueryValueEx(keyhand, strvalue, 0&, 0&, ByVal strBuf, lDataBufSize)
        If lResult = ERROR_SUCCESS Then
            intZeroPos = InStr(strBuf, Chr$(0))
            If intZeroPos > 0 Then
                GetString = Left$(strBuf, intZeroPos - 1)
            Else
                GetString = strBuf
            End If
        End If
    End If
End Function

Public Sub SaveString(hKey As Long, strPath As String, strvalue As String, strdata As String)
    Dim keyhand As Long
    Dim r As Long
    r = RegCreateKey(hKey, strPath, keyhand)
    r = RegSetValueEx(keyhand, strvalue, 0, REG_SZ, ByVal strdata, Len(strdata))
    r = RegCloseKey(keyhand)
End Sub

Function GetDWord(ByVal hKey As Long, ByVal strPath As String, ByVal strValueName As String) As Long
    Dim lResult As Long
    Dim lValueType As Long
    Dim lBuf As Long
    Dim lDataBufSize As Long
    Dim r As Long
    Dim keyhand As Long
    r = RegOpenKey(hKey, strPath, keyhand)
    lDataBufSize = 4
    lResult = RegQueryValueEx(keyhand, strValueName, 0&, lValueType, lBuf, lDataBufSize)
    If lResult = ERROR_SUCCESS Then
        If lValueType = REG_DWORD Then
            GetDWord = lBuf
        End If
    End If
    r = RegCloseKey(keyhand)
End Function

Function SaveDWord(ByVal hKey As Long, ByVal strPath As String, ByVal strValueName As String, ByVal lData As Long)
    Dim lResult As Long
    Dim keyhand As Long
    Dim r As Long
    r = RegCreateKey(hKey, strPath, keyhand)
    lResult = RegSetValueEx(keyhand, strValueName, 0&, REG_DWORD, lData, 4)
    r = RegCloseKey(keyhand)
End Function

Public Function DeleteKey(ByVal hKey As Long, ByVal strKey As String)
    Dim r As Long
    r = RegDeleteKey(hKey, strKey)
End Function

Public Function DeleteValue(ByVal hKey As Long, ByVal strPath As String, ByVal strvalue As String)
    Dim keyhand As Long
    r = RegOpenKey(hKey, strPath, keyhand)
    r = RegDeleteValue(keyhand, strvalue)
    r = RegCloseKey(keyhand)
End Function

Public Sub Delstring(hKey As Long, strPath As String, sKey As String)
    Dim keyhand&
    Dim r&
    r = RegOpenKey(hKey, strPath, keyhand&)
    r = RegDeleteValue(keyhand&, sKey)
    r = RegCloseKey(keyhand&)
End Sub

Public Sub SaveSet(AppName As String, Section As String, Key As Variant, value As Variant)
    SaveString HKEY_CURRENT_USER, "Software\" & app.CompanyName & "\" & AppName & "\" & Section, CStr(Key), CStr(value)
End Sub

Public Function GetSet(AppName As String, Section As String, Key As Variant, Optional default As Variant) As Variant
    GetSet = GetString(HKEY_CURRENT_USER, "Software\" & app.CompanyName & "\" & AppName & "\" & Section, CStr(Key))
    If GetSet = "" Then GetSet = default
End Function

Public Function DelSet(AppName As String, Section As String, Key As Variant) As Variant
    Delstring HKEY_CURRENT_USER, "Software\" & app.CompanyName & "\" & AppName & "\" & Section, CStr(Key)
End Function

Public Function CPUdata$(Optional ByVal what As String = "Identifier")
    CPUdata = GetString(HKEY_LOCAL_MACHINE, "Hardware\Description\System\CentralProcessor\0", what)
    Debug.Print "CPU"; what; CPUdata
End Function


Public Function CPUmhz() As Long
    CPUmhz = GetDWord(HKEY_LOCAL_MACHINE, "Hardware\Description\System\CentralProcessor\0", "~MHz")
    Debug.Print "CPU-MHz"; CPUmhz
End Function

