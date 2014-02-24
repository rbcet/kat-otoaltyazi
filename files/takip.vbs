Set WshShell = CreateObject("WScript.Shell") 
WshShell.Run """C:\Progra~1\FileBot\OtoAltyazi\takip.cmd"" " & WScript.Arguments.Item(0) & " """ & WScript.Arguments.Item(1) & """", 0
Set WshShell = Nothing

