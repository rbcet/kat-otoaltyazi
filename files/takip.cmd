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
ATTRIB -H %1\eski.txt 
ATTRIB -H %1\yeni.txt
ATTRIB -H %1\eklendi.txt
	echo. 2> %1\yeni.txt 
	dir /b /s "%1" | findstr /m /i "\.srt$" > %1\eski.txt 
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
findstr /G:%dosya1% /I /L /B /V %dosya2% > %1\eklendi.txt 
msg * /w < %1\eklendi.txt 
goto olustur 

:olustur 
dir /b /s "%1" | findstr /m /i "\.srt$"  > %1\eski.txt 
ATTRIB +H %1\eski.txt 
ATTRIB +H %1\yeni.txt
ATTRIB +H %1\eklendi.txt

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