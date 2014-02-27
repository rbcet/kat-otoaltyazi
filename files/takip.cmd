@echo off

:SETUP

	set watchsettings="C:\Program Files\FileBot\OtoAltyazi\takip_ayari.txt"

GOTO DetermineJobType


:DetermineJobType

	:: determine if adding or removing a task

	set var1=%1
	set var1=%var1:"=%

	set var2=%2
	set var2=%var2:"=%

	set var3=%var1:\=-%
	set var3=%var3::=%

	if "%var2%"=="setmatch" (
		goto ScheduleMatch
	) ELSE ( 
		if "%var2%"=="setmatch" (
			goto ScheduleMatch
		) ELSE (
			GOTO ERR1
			)
		)
	)

GOTO ERR1

:ScheduleMatch
	set currentParameter=%1	
	set he=Eklenen Altyazilar -
	set yok= Added Subtitles;
	set eklendibaslik=Klasore git? - Go to folder?
ATTRIB -H %1\eski.txt 
ATTRIB -H %1\yeni.txt
	
echo Option Explicit>> %1\eklendi.vbs
echo Const conForReading = ^1>> %1\eklendi.vbs
echo Dim objFSO, objReadFile, objFile, contents, result, shell>> %1\eklendi.vbs
echo Set objFSO = CreateObject("Scripting.FileSystemObject")>> %1\eklendi.vbs
echo Set objFile = objFSO.GetFile("%1\eklendi.txt") >> %1\eklendi.vbs
echo. >> %1\eklendi.vbs
echo If objFile.Size > 0 Then >> %1\eklendi.vbs
echo Set objReadFile = objFSO.OpenTextFile("%1\eklendi.txt", 1, False)>> %1\eklendi.vbs
echo contents = objReadFile.ReadAll>> %1\eklendi.vbs
echo result = MsgBox ("%he% %yok%" ^& vbCr ^& contents ^& "",vbYesNo+vbExclamation+vbSystemModal,"%eklendibaslik%")>> %1\eklendi.vbs
echo Select Case result>> %1\eklendi.vbs
echo Case vbYes>>  %1\eklendi.vbs
echo Set shell = wscript.CreateObject("Shell.Application")>> %1\eklendi.vbs
echo shell.Open "%1">> %1\eklendi.vbs
echo Case vbNo>> %1\eklendi.vbs
echo End Select>> %1\eklendi.vbs
echo objReadFile.close>> %1\eklendi.vbs
echo. >> %1\eklendi.vbs
echo Else >> %1\eklendi.vbs
echo End If  >> %1\eklendi.vbs
echo. >> %1\eklendi.vbs 
echo Set objFSO = Nothing >> %1\eklendi.vbs
echo Set objReadFile = Nothing >> %1\eklendi.vbs
echo WScript.Quit() >> %1\eklendi.vbs

 	echo. 2> %1\yeni.txt 
	dir /b /s "%1" | findstr /m /i "\.srt$" > %1\eski.txt 
	set filemask="%1\eski.txt"
	for %%A in (%filemask%) do if %%~zA==0 echo . >> %1\eski.txt
	
	for /f "tokens=*" %%i in ('findstr MATCH_VIDEO %watchsettings%') do set match=%%i
	call set match=%%match:PATH_HERE=%var1%%%
	call set match=%match:~0,-1%

	powershell %match%;
	
dir /b /s "%1" | findstr /m /i "\.srt$"  > %1\yeni.txt 
fc /b %1\eski.txt %1\yeni.txt|find /i "no differences">nul 
if errorlevel 1 goto farkli  
if not errorlevel 1 goto olustur

:farkli 
set dosya1="%1\eski.txt" 
set dosya2="%1\yeni.txt" 
setlocal enabledelayedexpansion    
for /f "delims=" %%a in ('findstr /G:%dosya1% /I /L /B /V %dosya2%') do (@echo %%~nxa >> %1\eklendi.txt )  
endlocal  
wscript %1\eklendi.vbs

goto olustur 

:olustur 
dir /b /s "%1" | findstr /m /i "\.srt$"  > %1\eski.txt 
ATTRIB +H %1\eski.txt 
ATTRIB +H %1\yeni.txt
ATTRIB -R -S -H %1\eklendi.txt
CD.>%1\eklendi.txt  
ATTRIB +H %1\eklendi.txt
del "%1\eklendi.vbs"
exit

	if not errorlevel 0 GOTO ERR1
	ECHO Scan Complete Folder: %var1% >> %logfile%

GOTO ALLOK


:ERR1
	echo Press any key to terminate install ...
	pause>nul
GOTO FINISH


:ALLOK
	echo ****** Job completed successfully *****
GOTO FINISH

:FINISH
EXIT /B