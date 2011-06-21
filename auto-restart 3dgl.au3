$ProcessName = "3dgl.exe"
	While 1
		If NOT ProcessExists($ProcessName) Then
			Run("3dgl.exe")
		EndIf
	sleep(5000)
Wend