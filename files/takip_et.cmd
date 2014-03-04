	@echo OFF

:ADMIN-CHECK

	:: BatchGotAdmin
	:-------------------------------------
	REM  --> Check for permissions
	>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

	REM --> If error flag set, we do not have admin.
	if '%errorlevel%' NEQ '0' (
	    echo Requesting administrative privileges...
	    GOTO DirCheck1
	) else ( GOTO gotAdmin )

	:DirCheck1

		copy /Y NUL "%~dp0\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%~dp0\.writable"
			GOTO UACPrompt1
		 ) else (
			echo Checking profile instead...
			GOTO DirCheck2
		)

	:DirCheck2

		copy /Y NUL "%USERPROFILE%\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%USERPROFILE%\.writable"
			GOTO UACPrompt2
		 ) else (
			echo Checking temp instead...
			GOTO DirCheck3
		)

	:DirCheck3

		copy /Y NUL "%tmp%\.writable" > NUL 2>&1 && set WRITEOK=1
		IF DEFINED WRITEOK ( 
			del "%tmp%\.writable"
			GOTO UACPrompt3
		 ) else (
			GOTO UACFailed
		)

	:UACPrompt1

		echo Set UAC = CreateObject^("Shell.Application"^) > "%~dp0\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params% "%1" "%2"", "", "runas", 1 >> "%~dp0\getadmin.vbs"

		"%~dp0\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%~dp0\getadmin.vbs"
			GOTO DirCheck2
		) else ( GOTO UACPrompt1Complete )

		:UACPrompt1Complete
			del "%~dp0\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACPrompt2

		echo Set UAC = CreateObject^("Shell.Application"^) > "%USERPROFILE%\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params% "%1" "%2"", "", "runas", 1 >> "%USERPROFILE%\getadmin.vbs"

		"%USERPROFILE%\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%USERPROFILE%\getadmin.vbs"
			GOTO DirCheck3
		) else ( GOTO UACPrompt2Complete )

		:UACPrompt2Complete
			del "%USERPROFILE%\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACPrompt3

		echo Set UAC = CreateObject^("Shell.Application"^) > "%tmp%\getadmin.vbs"
		set params = %*:"=""
		echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params% "%1" "%2"", "", "runas", 1 >> "%tmp%\getadmin.vbs"

		"%tmp%\getadmin.vbs"

		if '%errorlevel%' NEQ '0' (
			del "%tmp%\getadmin.vbs"
			GOTO UACFailed
		) else ( GOTO UACPrompt3Complete )

		:UACPrompt3Complete
			del "%tmp%\getadmin.vbs"
			exit /b
			GOTO gotAdmin

	:UACFailed
		echo Upgrading to admin privliages failed.
		echo Please right click the file and run as administrator.
		echo PAUSE
		GOTO FINISH

	:gotAdmin
		pushd "%CD%"
		CD /D "%~dp0"
	:--------------------------------------

GOTO SETUP

:SETUP

	:: set watchsettings="C:\Program Files\FileBot\OtoAltyazi\takip_ayari.txt"
	set watchfile="C:\Progra~1\FileBot\OtoAltyazi\takip.cmd"
	set "watchlist=C:\Progra~1\FileBot\OtoAltyazi\gorev_listesi.txt"
	set "watchlist2=%tmp%\gorev_listesi_tmp.txt"

GOTO DetermineJobType


:DetermineJobType

	:: determine if adding or removing a task

	set var1=%1
	set var1=%var1:"=%

	set var2=%2
	set var2=%var2:"=%

	set var3=%var1:\\=%
	set var3=%var3:_=%
	set var3=%var3:\=_%
	set var3=%var3::=%
	set var3=%var3: =%
	set var3=%var3:(=%
	set var3=%var3:)=%
	set var3=%var3:;=%
	set var3=%var3:'=%
	set var3=%var3:.=%
	set var3=%var3:,=%
	set var3=%var3:-=%
	set var3=%var3:+=%
	set var3=%var3:{=%
	set var3=%var3:}=%
	set var3=%var3:[=%
	set var3=%var3:]=%
	set var3=%var3:!=%
	set var3=%var3:@=%
	set var3=%var3:#=%
	set var3=%var3:$=%
	set var3=%var3:^=%
	set var3=%var3:&=%

	if "%var2%"=="setmatch" (
		goto AskDetails
	) ELSE ( 
		if "%var2%"=="setmatch" (
			goto AskDetails
		) ELSE (
			if "%var2%"=="removetask" (
				goto RemoveTask
			) ELSE (
				GOTO ERR1
			)
		)
	)

GOTO ERR1


:AskDetails

	GOTO ask-metric

	:ask-metric

		call :inputbox "Input for, dakika-minutes 1,saat-hour 2,gun-day 3,hafta-week icin 4,ay-month 5, girin." "Hangi araliklarla (interval metric)?" "2"

		if NOT "%Input%"=="" (
			GOTO metric-check
		) ELSE (
			GOTO metric-default
		)

		:metric-check
		SET /A TestVal="%Input%"*1

		if "%TestVal%"=="%Input%" (
			GOTO metric-fixed
		) ELSE (
			:: input was not a number
			GOTO metric-default
		)

		:metric-fixed
			set "scanmetric=%Input%"
			IF %scanmetric% LEQ 0 (
				goto metric-default
			) ELSE IF %scanmetric% EQU 1 (
				set "scanmetric=minute"
				set "metricterm=minutes"
				set "termlimits=Limit: 1 - 1439 %metricterm%"
			) ELSE IF %scanmetric% EQU 2 (
				set "scanmetric=hourly"
				set "metricterm=hours"
				set "termlimits=Limit: 1 - 23 %metricterm%"
			) ELSE IF %scanmetric% EQU 3 (
				set "scanmetric=daily"
				set "metricterm=days"
				set "termlimits=Limit: 1 - 365 %metricterm%"
			) ELSE IF %scanmetric% EQU 4 (
				set "scanmetric=weekly"
				set "metricterm=weeks"
				set "termlimits=Limit: 1 - 52 %metricterm%"
			) ELSE IF %scanmetric% EQU 5 (
				set "scanmetric=monthly"
				set "metricterm=months"
				set "termlimits=Limit: 1 - 12 %metricterm%"
			) ELSE (
				goto metric-default
			)
			echo New Scheduling Metric: %scanmetric% 
		GOTO ask-units

		:metric-default	
			set "scanmetric=daily"
			set "metricterm=days"
			set "termlimits=Limit: 1 - 365 %metricterm%"
			echo No Valid Scheduling Metric Detected. Defaulting to %scanmetric% 
		GOTO ask-units

	:ask-units

		call :inputbox "%metricterm%? (%termlimits%)" "%metricterm%?" "1"

		if NOT "%Input%"=="" (
			GOTO units-check
		) ELSE (
			GOTO units-default
		)

		:units-check
		SET /A TestVal="%Input%"*1

		if "%TestVal%"=="%Input%" (
			GOTO units-fixed
		) ELSE (
			:: input was not a number
			GOTO units-default
		)

		:units-fixed

			set "scanunits=%Input%"

			if "%scanmetric%"=="minute" (
				:: check against minute limits between 1 - 1439
				IF %scanunits% LEQ 0 (goto units-default)
				IF %scanunits% GEQ 1440 (goto units-default)
			)

			if "%scanmetric%"=="hourly" (
				:: check against hourly limits between 1 - 23
				IF %scanunits% LEQ 0 (goto units-default)
				IF %scanunits% GEQ 24 (goto units-default)
			)

			if "%scanmetric%"=="daily" (
				:: check against daily limits between 1 - 365
				IF %scanunits% LEQ 0 (goto units-default)
				IF %scanunits% GEQ 366 (goto units-default)
			)

			if "%scanmetric%"=="weekly" (
				:: check against weekly limits between 1 - 52
				IF %scanunits% LEQ 0 (goto units-default)
				IF %scanunits% GEQ 53 (goto units-default)
			)

			if "%scanmetric%"=="monthly" (
				:: check against monthly limits between 1 - 12
				IF %scanunits% LEQ 0 (goto units-default)
				IF %scanunits% GEQ 13 (goto units-default)
				)
			)

			echo Number of %metricterm%: %scanunits% 

		GOTO CreateTask

		:units-default
			set "scanunits=1"
			echo No Valid Metric Detected. Defaulting to %scanunits% 
		GOTO CreateTask

	if not errorlevel 0 GOTO ERR1

GOTO CreateTask


:CreateTask
@echo off
	ECHO Yandaki icin klasor takibi olusturuluyor %var1% 
	schtasks /create /sc %scanmetric% /mo %scanunits% /tn "Takip %var3%" /tr "%%ProgramW6432%%\FileBot\OtoAltyazi\takip.vbs \"%1\" \"%2\"" /F
	echo Takip %var3%>> "%watchlist%"
	
	if not errorlevel 0 GOTO ERR1

	GOTO ALLOK


:RemoveTask
	@echo off
	ECHO Yandaki icin klasor takibi kaldiriliyor %var1% 
	:: remove task for this folder
	schtasks /delete /TN "Takip %var3%" /f 
	findstr /v /i "%var3%" "%watchlist%" > "%watchlist2%"
	type "%watchlist2%" > "%watchlist%"
	del "%watchlist2%"
	DEL /Q /a:H "%var1%\eski.txt"
	DEL /Q /a:H "%var1%\yeni.txt"
	DEL /Q /a:H "%var1%\eklendi.txt"

	ECHO Takip kaldirildi

	if not errorlevel 0 GOTO ERR1

GOTO ALLOK


:InputBox
	set input=
	set default=%~3
	set heading=%~2
	set message=%~1
	echo wscript.echo inputbox(WScript.Arguments(0),WScript.Arguments(1),WScript.Arguments(2)) >"%~dp0\input.vbs"
	for /f "tokens=* delims=" %%a in ('cscript //nologo "%~dp0\input.vbs" "%message%" "%heading%" "%default%"') do set input=%%a
	del %~dp0\input.vbs
exit /b


:ERR1
	echo **** Hata **** 
	echo. 
	echo Iptal etmek icin bir tusa basin ...
	pause>nul
GOTO FINISH


:ALLOK
	echo ****** Basariyla tamamlandi ***** 
	echo. 
GOTO FINISH


:FINISH
EXIT /B