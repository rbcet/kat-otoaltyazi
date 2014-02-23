Set WshShell = CreateObject("WScript.Shell")

WshShell.Run """C:\Program Files\FileBot\OtoAltyazi\takip.bat"" " & WScript.Arguments.Item(0) & " """ & WScript.Arguments.Item(1) & """", 0

Set WshShell = Nothing