
;esto hay que hacerlo con arrays pero me da paja =D

$ProcessName0 = "ADZSERVER0.exe"
$ProcessName1 = "ADZSERVER1.exe"
$ProcessName2 = "ADZSERVER2.exe"
$ProcessName3 = "ADZSERVER3.exe"
$ProcessName4 = "ADZSERVER4.exe"

	While 1
		If NOT ProcessExists($ProcessName0) Then
			Run($ProcessName0)
		EndIf
		If NOT ProcessExists($ProcessName1) Then
			Run($ProcessName1)
		EndIf
		If NOT ProcessExists($ProcessName2) Then
			Run($ProcessName2)
		EndIf
		If NOT ProcessExists($ProcessName3) Then
			Run($ProcessName3)
		EndIf
		If NOT ProcessExists($ProcessName4) Then
			Run($ProcessName4)
		EndIf
	sleep(10000)
Wend